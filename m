Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3J1HZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:25:03 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37846 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3J1HZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:25:00 -0400
MIME-Version: 1.0
Date: Mon, 28 Oct 2013 12:54:57 +0530
Message-ID: <CAPUj1ONAa+6AjR9APOhi=QpmKJY6afpmsPvVcb3ecApBj_pRJg@mail.gmail.com>
Subject: ARM GIC Virtualization question
From: Mj Embd <mj.embd@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Simon Glass <sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

a) As per GIC-400 all Physical interrupts trap into hypervisor
b) Hypervisor does ACK, programs Virtual GIC list registers (with
PhysIRQ:VIRQ) and does a world switch.
c) GIC CPU I/f interrupts Guest with the VIRQ
d) Guest does a ACK and EOI to GIC cpu i/f
e) Hypervisor gets a maintenance interrupt when Guest Does an EOI
f) Hypervisor then clears the Physical Interrupt

So for 1 interrupt there are so many context switches ? Is the
sequence right. If I am missing anything please let me know ..

Also, If a device is private to a guest, so many context switches
would reduce the performance if the device interrupts a lot.

My question is that
a) Is the above flow correct ?
b) Is this the only flow or there exists some optimisations


Thanks and Regards
