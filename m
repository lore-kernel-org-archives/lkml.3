Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab3DBC7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:59:32 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50559 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab3DBC7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:59:31 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r322xOHD030402, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com> <1364824539-4156-6-git-send-email-hayeswang@realtek.com> <20130401222335.GC19335@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 6/7] r8169: add a new chip for RTL8106E
Date: Tue, 2 Apr 2013 10:59:29 +0800
Message-ID: <AB471B8BF00E49B38C3F20840B5B82A2@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4vJ4/KxyScUuqfStWPuKtkU1h8mgAI15uw
In-Reply-To: <20130401222335.GC19335@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Tuesday, April 02, 2013 6:24 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 6/7] r8169: add a new chip for RTL8106E
> 
> Hayes Wang <hayeswang@realtek.com> :
> [...]
> > - move rtl_set_rx_tx_desc_registers to avoid the tx/rx are enabled
> >   before setting desc registers.
> 
> This is a wholesale change for the 810x family.
> 
> Please explain why issuing rtl_set_rx_tx_desc_registers before writing
> ChipCmd is not enough and feed it through a standalone commit.
> 

According to the new initial flow of this new chip, the tx/rx would be enabled
in rtl_hw_start_8168g_2 function. And this function is run before
rtl_set_rx_tx_desc_registers. It would be a problem, so I move
rtl_set_rx_tx_desc_registers to make sure that the descriptor address would be
set before the tx/rx is enabled. It has no influence for the previous chips, and
I think the following new chips would base on the new flow.
 
Best Regards,
Hayes

