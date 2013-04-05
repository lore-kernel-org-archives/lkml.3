Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162185Ab3DERFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:05:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55439 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162023Ab3DERFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:05:16 -0400
Message-ID: <515F0456.9040803@sgi.com>
Date: Fri, 5 Apr 2013 12:05:26 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
References: <515D9F8A.2060505@sgi.com> <1365090819-25448-1-git-send-email-nzimmer@sgi.com> <20130404161140.GR21522@ZenIV.linux.org.uk> <515DB465.1060004@sgi.com> <20130404204459.GU21522@ZenIV.linux.org.uk>
In-Reply-To: <20130404204459.GU21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:44 PM, Al Viro wrote:
> On Thu, Apr 04, 2013 at 12:12:05PM -0500, Nathan Zimmer wrote:
>
>> Ok I am cloning the tree now.
>> It does look like the patches would conflict.
>> I'll run some tests and take a deeper look.
> FWIW, I've just pushed there a tentative patch that switches to hopefully
> saner locking (head should be at cb673c115c1f99d3480471ca5d8cb3f89a1e3bee).
> Is that more or less what you want wrt spinlock contention?
>
> One note: for any given pde_opener, close_pdeo() can be called at most
> by two threads - final fput() and remove_proc_entry() resp.  I think
> the use of completion + flag is safe there; pde->pde_unload_lock
> should serialize the critical areas.

Something isn't quite right.  I keep getting hung during boot.
dracut: Mounted root filesystem /dev/sda8
dracut: Switching root

I'll try to get some more info on a smaller box.
