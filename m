Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaFMO6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:58:04 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48549 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaFMO6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:58:01 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wei.Yang@windriver.com, balbi@ti.com, andrzej.p@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <Pine.LNX.4.44L0.1406130939540.1059-100000@iolanthe.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1406130939540.1059-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140613:balbi@ti.com::xexeTrmMw14E31SE:000001ASs
X-Hashcash: 1:20:140613:linux-kernel@vger.kernel.org::9xtYODAre41WpUGs:0000000000000000000000000000000000WFI
X-Hashcash: 1:20:140613:andrzej.p@samsung.com::/1hv6N2ANvC3tEeW:00000000000000000000000000000000000000000m30
X-Hashcash: 1:20:140613:linux-usb@vger.kernel.org::cDcmPS03lNbiJWM7:0000000000000000000000000000000000002eYZ
X-Hashcash: 1:20:140613:stern@rowland.harvard.edu::pjUdkLJYxjJi37Wz:0000000000000000000000000000000000003IbN
X-Hashcash: 1:20:140613:wei.yang@windriver.com::c1M1cdOS7VrKVMmv:000000000000000000000000000000000000000BJa/
Date: Fri, 13 Jun 2014 16:57:56 +0200
Message-ID: <xa1t8up0oo0b.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 13 Jun 2014, Michal Nazarewicz wrote:
>
>> > The root cause is that the existing code fails to take into
>> > account the possibility that common->new_fsg can change while
>> > do_set_interface() is running, because the spinlock isn't held
>> > at this point.
>> 
>> common->new_fsg is not protected by common->lock so this justification
>> is not valid.
>
> That's true.  A better justification would be that the same value of 
> new_fsg should be used in do_set_interface() and in the test that 
> follows.
>
>> > @@ -2421,6 +2422,7 @@ static void handle_exception(struct fsg_common *common)
>> >  		}
>> >  		common->state = FSG_STATE_IDLE;
>> >  	}
>> > +	new_fsg = common->new_fsg;
>> 
>> Also, because common->new_fsg is not protected by common->lock, doing
>> this under a lock is kinda pointless.
>
> Yes, but it doesn't hurt.
>
>> >  	spin_unlock_irq(&common->lock);
>> >  
>> >  	/* Carry out any extra actions required for the exception */
>> > @@ -2460,8 +2462,8 @@ static void handle_exception(struct fsg_common *common)
>> >  		break;
>> >  
>> >  	case FSG_STATE_CONFIG_CHANGE:
>> > -		do_set_interface(common, common->new_fsg);
>> > -		if (common->new_fsg)
>> > +		do_set_interface(common, new_fsg);
>> > +		if (new_fsg)
>> >  			usb_composite_setup_continue(common->cdev);
>> 
>> As far as I can tell, it's safe to move the assignment to new_fsg here,
>> e.g.:
>> 
>> 		new_fsg = common->new_fsg;
>> 		do_set_interface(common, new_fsg);
>> 		if (new_fsg)
>> 			usb_composite_setup_continue(common->cdev);
>
> That would be equally correct.  I don't see any strong reason for 
> preferring one over the other.

Doing the read under the lock may give an impression that the value is
indeed protected by the lock.  Doing it outside of the lock creates no
such confusion.  Therefore, I would prefer having the read outside.  But
no strong feelings.

>> >  		break;
>> 
>> But perhaps new_fsg should be protected by the lock.  I think valid fix
>> (which I did not test in *any* way) will be this:

> No, I think this change is both too big and unnecessary.  
> common->new_fsg does not need protection; in a sense it is "owned" by 
> the composite driver.

No strong feelings on my side.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
