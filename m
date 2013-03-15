Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3CORHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:07:15 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:64952 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920Ab3CORHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:07:13 -0400
X-TM-IMSS-Message-ID: <ce75f73800181886@nsa.gov>
Message-ID: <51435534.3090007@tycho.nsa.gov>
Date: Fri, 15 Mar 2013 13:07:00 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas COUDRAY <amanone@gmail.com>
CC: jmorris@namei.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Subject: Re: lgetxattr()/getxattr() return different values on a file labelled
 with selinux disabled
References: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com> <514319D4.6050200@tycho.nsa.gov> <CABhRnsXJ6RJ1wPDy_Z3cHmx8q9zdOHDRi5cxt-PFMKcYVv7xpA@mail.gmail.com>
In-Reply-To: <CABhRnsXJ6RJ1wPDy_Z3cHmx8q9zdOHDRi5cxt-PFMKcYVv7xpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 11:24 AM, Thomas COUDRAY wrote:
> 2013/3/15 Stephen Smalley <sds@tycho.nsa.gov>:
>> f is truly a regular file and not a symlink pointing to a regular file?
>
> f is a truly regular file.
>
>> before_t and after_t are both defined in the policy?
>
> Only before_t was defined in the policy.

If not defined in policy, then kernel should remap to unlabeled sid 
context.

> When I define after_t in the policy, both commands return the same
> label (after_t).
> But I wouldn't expect this to make a difference in the output of both
> commands (as the only visible difference is lgetxattr() vs getxattr())

getxattr security.* results are supplied by the security module rather 
than the filesystem to allow the value to be canonicalized.  But this 
should happen the same for lgetxattr and getxattr; those should only 
differ if the file is a symlink.

>> before_t and after_t are not type aliases of each other?
>
> They are not.
>
>> What are the credentials (capabilities and SELinux security
>> context/permissions) of the process running the ls and getfattr commands?
>
> It has unconfined_u:unconfined_r:before_t label with before_t type.
> Same as the file f.
> The process has full SELinux rights on both command and file.

Did it run as root?  Does it have :capability2 mac_override permission?

>> Any relevant messages from SELinux in dmesg output?
>
> No avc warnings in dmesg and audit.log. All looks good.

What about SELinux: messages?  e.g. SELinux:  Context ... is not valid 
(left unmapped).


