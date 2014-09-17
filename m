Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbaIQRfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:35:55 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37802 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbaIQRfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com>
References: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com>
Date: Wed, 17 Sep 2014 10:35:53 -0700
Message-ID: <CAA9CXT0rzh95LModNmniaOzQOcYAecJC9ey_VDDvfJsxbhBatQ@mail.gmail.com>
Subject: Fwd: irq mask swapping during suspend/resume
From: Eric Caruso <ejcaruso@google.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        Benson Leung <bleung@google.com>, Dmitry Torokhov <dtor@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending in plain text. Sorry about the HTML.)

Hi,

We would like to be able to set different irq masks for triggers
during normal operation and for waking up the system. For example,
while a laptop is awake, closing the lid and opening the lid should
both fire an interrupt, but when the system is asleep, we would like
to stay asleep when closing the lid.

We are thinking about stashing the irq mask used specifically for
waking the system up in the irq_desc struct, and then swapping it
during enable_irq_wake and disable_irq_wake calls. Devices that do not
specify a different wake mask will use their normal trigger mask for
both situations.

Is this acceptable?

Thanks,
Eric
