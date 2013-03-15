Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3CONIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:08:39 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:50072 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754478Ab3CONIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:08:36 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Mar 2013 09:08:36 EDT
X-TM-IMSS-Message-ID: <cd8dfa4f0017c1c8@nsa.gov>
Message-ID: <514319D4.6050200@tycho.nsa.gov>
Date: Fri, 15 Mar 2013 08:53:40 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas COUDRAY <amanone@gmail.com>
CC: jmorris@namei.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Subject: Re: lgetxattr()/getxattr() return different values on a file labelled
 with selinux disabled
References: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com>
In-Reply-To: <CABhRnsWdD6Ef1kg=bud7RKpsQ7KeUhuQEw4Z2N_0RePgS=QDGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Thomas COUDRAY wrote:
> Hi,
> I encounter trouble that I can't explain when labelling my files.
> Here are steps to reproduce (on both 3.2.37 and 3.7.3, with selinux, on
> an ext4 fs):
> 0 - have a regular file "f", with a "before_t" security.selinux attribute
> 1 - reboot with selinux=0
> 2 - change the label to "after_t" (setfattr or chcon)
> 3 - both "ls -Z" (who calls lgetxattr(2)) and "getfattr -n
> security.selinux" (who calls getxattr(2)) show "after_t"
> 4 - reboot with selinux enabled
> 5 - now ls prints "before_t", and getfattr "after_t".
>
> I ran a small test that calls both syscalls (lgetxattr/getxattr), I
> get "before_t" as expected
> If I touch /.autorelabel, both ls/getfattr give "before_t".

f is truly a regular file and not a symlink pointing to a regular file?
before_t and after_t are both defined in the policy?
before_t and after_t are not type aliases of each other?
What are the credentials (capabilities and SELinux security 
context/permissions) of the process running the ls and getfattr commands?
Any relevant messages from SELinux in dmesg output?


