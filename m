Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3JWJG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:06:26 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56796 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3JWJGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:06:25 -0400
Date: Wed, 23 Oct 2013 11:06:18 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, linux-arm-kernel@lists.infradead.org
Subject: userspace firmware load fails with current linux-next
Message-ID: <20131023110618.7bd07899@ipc1.ka-ro>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with the current linux-next loading firmware from userspace fails
because when writing to /sys/class/firmware/*/data the return code is
always 0 (meaning to the userspace too that no data was written).
Thus the userspace tool (mdev) keeps writing the same block of data
over and over again.

A cursory check of the latest updates to /drivers/base/firmware* didn't
reveal anything that could be the cause of this misbehaviour.

Interestingly when changing the .size member of the
struct bin_attribute firmware_attr_data in drivers/base/firmware_class.c
(which is now '0') to e.g. PAGE_SIZE firmware loading works again.

Since .size was at '0' since the beginning of the .git universe there
must have been a fundamental change in the guts of the kernel handling
sysfs attribute files.

Is this behavioural change intended?
Do all sysfs attributes that are created with zero size need to be
changed?
Or is it an unintended side effect of some recent change?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
