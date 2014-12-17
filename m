Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaLQPi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:38:58 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:40277 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQPiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:38:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141217064802.GA4971@hudson.localdomain>
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
	<1418624603-19054-10-git-send-email-dudley.dulixin@gmail.com>
	<20141216135639.GA1238@hudson.localdomain>
	<CANLzEks+hyNGy4_c+pHPW203oZUY=ms-cF3CttkW2NyRmNt8Zw@mail.gmail.com>
	<20141217064802.GA4971@hudson.localdomain>
Date: Wed, 17 Dec 2014 07:38:55 -0800
X-Google-Sender-Auth: 6ewAKkd47t30oL_F8bBdOXPGE_E
Message-ID: <CANLzEkvJvK1rEiUYGKqn7-1AW4DzeZ4t_+pupW=okRB=O_meFA@mail.gmail.com>
Subject: Re: [PATCH v15 09/12] input: cyapa: add gen5 trackpad device firmware
 update function support
From: Benson Leung <bleung@chromium.org>
To: Jeremiah Mahler <jmmahler@gmail.com>, Benson Leung <bleung@google.com>,
        Dudley Du <dudley.dulixin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:48 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> So DESIGNWARE_PCI isn't required for all devices.  But if MOUSE_CYAPA is
> enabled some devices won't work unless I2C_DESIGNWARE_PCI is enabled.  I
> wonder if MOUSE_CYAPA should be broken up in to separate working
> configurations?  MOUSE_CYAPA_GEN5, MOUSE_CYAPA_GEN3, ?

Splitting into two configs doesn't help either. Currently, all Cypress
devices available for Chromebooks are Gen 3. This includes the ARM
Samsung Chromebook which doesn't use I2C_DESIGNWARE_PCI, and the
C720/HP Chromebook 14/Dell Chromebook 11 which do require
I2C_DESIGNWARE_PCI.

The right thing to do would be to add the the I2C_DESIGNWARE_PCI
depend for the CHROMEOS_LAPTOP config. The chromeos_laptop driver
actually refers to I2C_DESIGNWARE_PCI by name, so it is appropriate
there.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
