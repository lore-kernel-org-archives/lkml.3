Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbbAYVRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:17:33 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35578 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbAYVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:17:29 -0500
Message-ID: <54C55D67.8060503@hurleysoftware.com>
Date: Sun, 25 Jan 2015 16:17:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] tty: serial: men_z135_uart: Fix driver for changes
 in hardware
References: <1421649881-2275-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1421649881-2275-1-git-send-email-johannes.thumshirn@men.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 01:44 AM, Johannes Thumshirn wrote:
> 16z135 IP Core has changed so the driver needs to be updated to respect
> these changes. The following changes have been made:
> 
> * Don't invert the 16z135 modem status register when reading.
> * Add module parameter to configure the (baud rate dependent) RX timeout.
>   Character timeout in seconds = (timeout_reg * baud_reg * 4)/freq_reg.
> * Enable the handling of UART core's automatic flow control feature.
>   When AFE is active disable generation of modem status IRQs.
> * Rework the handling of IRQs to be conform with newer FPGA versions and
>   take precautions not to miss an interrupt because of the destructive read
>   of the IIR register.
> * Correct men_z135_handle_modem_status(), MSR is stat_reg[15:8] not
>   stat_reg[7:0]
> * Correct calling of uart_handle_{dcd,cts}_change()
> * Reset CLOCAL when CRTSCTS is set

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

