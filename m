Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3KQTKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 14:10:35 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41993 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KQTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 14:10:28 -0500
MIME-Version: 1.0
Date: Sun, 17 Nov 2013 17:10:27 -0200
Message-ID: <CAGG-pUTye8ovBDvryN7GNPPCUmPJf9VhQ_hCbxJ9ABmz787H8A@mail.gmail.com>
Subject: [RFC] possible null dereference in 'pm121_create_sys_fans()'
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Benjamin,

In file 'windfarm_pm121'.c:

If this branch is true:

    if (param == NULL) {
        printk(KERN_WARNING "pm121: %s fan config not found "
               " for this machine model\n",
               loop_names[loop_id]);
        goto fail;
    }

control that is NULL will suffer a dereference attempt:

fail:
    /* note that this is not optimal since another loop may still
       control the same control */
    printk(KERN_WARNING "pm121: failed to set up %s loop "
           "setting \"%s\" to max speed.\n",
           loop_names[loop_id], control->name);


Reported-by: Geyslan G. Bem <geyslan@gmail.com>

-- 
Regards,

Geyslan G. Bem
hackingbits.com
