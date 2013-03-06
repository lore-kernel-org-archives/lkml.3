Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3CFOLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:11:12 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:53901 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3CFOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:11:08 -0500
Message-ID: <51374E79.9050408@free-electrons.com>
Date: Wed, 06 Mar 2013 15:11:05 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@freescale.com>
Subject: Re: v3.9-rc1: swapper/0 [ INFO: possible circular locking dependency
 detected ]
References: <51371B5E.1000508@free-electrons.com> <CAB7JpEHJdKeOhkME-6mMdPY6VyTQwFvM33+gxg4X9ZpQv1=6RQ@mail.gmail.com>
In-Reply-To: <CAB7JpEHJdKeOhkME-6mMdPY6VyTQwFvM33+gxg4X9ZpQv1=6RQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks for your reply.

Le 06/03/2013 14:43, Alexander Shishkin a écrit :
> On 6 March 2013 12:33, Maxime Ripard 
> <maxime.ripard@free-electrons.com> wrote:
>> Just noticed this in 3.9-rc1 on an iMX28 (ARM) board with a config
>>  based on mxs_defconfig. I'm using the patchset "Add tested id 
>> switch and vbus connect detect support for Chipidea" from Peter 
>> Chen in its 10th version [1], rebased on top of 3.9-rc1, but since 
>> this doesn't modify the locks present in the udc_irq function, I 
>> think the problem is elsewhere.
> 
> From a quick look at the current chipidea code, I don't see any place
> where we might try to take cdev->lock under ci->lock. I should have a
> better look at Peter's patchset to see if it can trigger that.

And from a quick git blame on top of Peter patches, it seems like
udc_irq has been left untouched by his patches.

> Peter, have you seen anything like that with your code? Is this easy
>  to trigger (I would assume it is)?

Quite easy yes, just plug a usb cable in gadget mode.

> Can you post the contents of "events" debug file in sysfs?

http://code.bulix.org/64liql-83101


-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
