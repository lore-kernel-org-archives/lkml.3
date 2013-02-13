Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab3BMRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:13:58 -0500
Received: from mx2.promwad.com ([91.149.128.90]:18380 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab3BMRN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:13:57 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 12:13:57 EST
Date: Wed, 13 Feb 2013 20:08:26 +0300
From: Michail Kurachkin <michail.kurachkin@promwad.com>
X-Mailer: The Bat! (v3.64.01 Christmas Edition) Professional
Reply-To: promwad_imap <michail.kurachkin@promwad.com>
Organization: promwad
X-Priority: 3 (Normal)
Message-ID: <1634686041.20130213200826@promwad.com>
To: Oliver Neukum <oneukum@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re[2]: TDM bus support in Linux Kernel [PATCH]
In-Reply-To: <5007545.bVNiTjB1se@linux-5eaq.site>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp> <1445550.3M3gD8CvZe@linux-5eaq.site> <6757302.20130204160858@promwad.com> <5007545.bVNiTjB1se@linux-5eaq.site>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just sent reworked version of the code. I am looking forward for comments.
Sorry, I have no time to fix your next requests:

1) It's a bit clunky having two device types on the same character device. Is there a better way to do this?

2) + mutex_lock(&slic_chr_dev_lock);
This locking is very heavy handed. You are holding it across the entire open, close, read, write, ioctl, and it is protecting a bunch of different things. Can you make the locking a bit more fine grained?

3) + rc = add_to_slic_devices_list(&tdm_dev->dev, TDM_DEVICE);
This function is the same as probe_spi_slic, except for the device type. A single function would prevent the code duplication.

Will do it later.


Thanks,
Michail


> On Monday 04 February 2013 16:08:58 Michail Kurachkin wrote:
>> Hi Oliver,
>> 
>> Thank you for the code review. I am working on the sources and soon
>> will send you the update.
>> 
>> By the way, I did not find suitable implementation of software circular buffer management. src/include/linux/circ_buf.h seems to be very limited solution. 
>> What do you think about adding the following functions/macros to the global namespace?

> Additions to the global namespace needs to be done very carefully.

>> int cb_init(struct circ_buf *cb, int item_size, int count);
>> void cb_free(struct circ_buf *cb);
>> int cb_push(struct circ_buf *cb, void *item);
>> int cb_pop(struct circ_buf *cb, void *item);

> void pointers here may be suboptimal

>> int cb_is_full(struct circ_buf *cb);
>> int cb_is_empty(struct circ_buf *cb);

> I suggest you implement them in private and if they serve you well,
> we can discuss making them global. The important point is that you
> don't duplicate code.

>         Regards
>                 Oliver



--
Kurochkin Michail
Software engineer
Promwad Innovation Company
22, Olshevskogo St.,
220073, Minsk, BELARUS
phone: +375 17 312-1246 ext. 801
mobile: +375 29 609-1024
mail: Michail.Kurachkin@promwad.com
www: www.promwad.com

