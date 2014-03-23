Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaCWOUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 10:20:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:57830 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaCWOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 10:20:35 -0400
Message-Id: <20140323141648.703530841@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 14:20:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch 0/2] workqueue: Add proper debugobjects support for
 delayed_work on stack
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to decode Vince mystery crash I noticed, that we have a
initializer for delayed work on stack but no destructor.

The only user in tree got it wrong, which leaks a tracking object for
the work itself.

Provide destroy_delayed_work_on_stack() and make hpet use it.

Thanks,

	tglx

