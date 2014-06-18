Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaFRPPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:15:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:44905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaFRPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:15:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gobinda Charan Maji <gobinda.cemk07@gmail.com>
Subject: Re: Stricter module param and sysfs permission checks
Date: Wed, 18 Jun 2014 15:07:25 +0000 (UTC)
Message-ID: <loom.20140618T155046-940@post.gmane.org>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org> <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722> <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au> <1395211832.8649.40.camel@joe-AO722> <87k3bpr28n.fsf@rustcorp.com.au> <20140320042700.GA11505@redhat.com> <87ob10vnp9.fsf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 111.93.164.254 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik <at> free.fr> writes:

> 
> Dave Jones <davej <at> redhat.com> writes:
> 
> > On Thu, Mar 20, 2014 at 01:43:44PM +1030, Rusty Russell wrote:
> >
> >  > drivers/mtd/devices/docg3.c:
> >  >  	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, 
dps0_insert_key), \
> >  > 	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), 
\
> >  > 
> >  > drivers/scsi/pm8001/pm8001_ctl.c:
> >  > static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
> >  > 	pm8001_show_update_fw, pm8001_store_update_fw);
> >
> > Why on earth are these world writable ?
> For docg3, this attributes are used to input a "password" into the flash 
chip,
> to unlock parts of the flash memory. By unlock I mean that a sector read 
will
> return the actual sector when unlocked, and only 0xff if not read 
unlocked.
> 
> As to the "why writable" by "others", the legacy reason is that when I 
wrote
> that code I had in mind that a casual user count :
>  - input the code : "echo secret > dps0_protection_key"
>  - mount /usermount
> 
> That's not a good reason, I know, and changing that to remove the "other" 
write
> permission is fine by me.
> 
> Cheers.
> 

Hi All,

As per the newly added restriction (User perms >= group perms >= other 
perms) is concerned, there is an inconsistency in the permission. Say for 
example, permission value is "0432". Here User has only READ permission 
whereas Group has both WRITE and EXECUTE permission and Other has WRITE 
permission. I think it is not good to give Group and Other at least WRITE 
permission whereas User itself has no WRITE permission.

May be, it's better to check those three permissions bit wise rather than as 
a whole. Please rethink about my point and let me know your opinion.

Thanks,
Gobinda



