Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab3IBWqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 18:46:46 -0400
Received: from nm13-vm1.access.bullet.mail.gq1.yahoo.com ([216.39.63.11]:48052
	"EHLO nm13-vm1.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759062Ab3IBWqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 18:46:45 -0400
X-Yahoo-Newman-Id: 653247.89008.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aRmzdzMVM1m9LEFAJdETVNmQ1dyrrxo92w_mowyNOch_imo
 QvleR77FxSgJPut18nP_IpPAn5FQs6zVNfLO1G0xWEVuXct5Wi4EBiO7gqnr
 HvHoNWgG.eMzgf.7sP6LwOnet5Qzxc4ygIoiRfZc3EuAsW.5ndusX2MpRwjE
 gbLf_PUdjmHyotr4yZ93p.C.rr1TYi.ya9Pi64ruUxRnkIXCO2W6x2CalN98
 m7O3fGHZYRdVoxrmlSRPKWpS3mnljC5U9zwbiSnCiShO1FGRSZ1Z8ho4wxrn
 QUWMj5799D6SmR7NBr7iXkzL5GG0l1eKvxYc5TIoz0xQqyWE6bZ_bEFQzHXN
 Kc0loKsFojTF3XD28a_uzqdLXASVLFlWv9cxml_dUaY1sQJy_7rMzCdFXB4k
 fUIp1CzI9dS5whMmhDTsMdmtmXmxce967O8SZOPdfb..0pNo_ogovUSkDE8U
 zWboVLi5.jFh2.7n.mD_R5d3C6L.6VeT.kZohYxTCMMxwHprqXw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp109.sbc.mail.ne1.yahoo.com with SMTP; 02 Sep 2013 15:46:44 -0700 PDT
Message-ID: <52251562.5000208@att.net>
Date: Mon, 02 Sep 2013 17:46:58 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: RESEND: Generating interrupts from a USB device driver?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys.  I didn't get a response the last time so hopefully with 
3.11 out I'll get one this time.

I need to be able to generate interrupts from a USB device driver while 
servicing the complete() function of an interrupt URB. While I realize 
that this may seem strange, the purpose is for a USB to SPI/GPIO bridge 
chip (the MCP2210). When something happens on the remote device where a 
chip is expecting it's interrupt out pin to trigger an interrupt on some 
local (to the board) microcontroller, the MCP2210 instead receives that 
signal and communicates it to the host the next time it's queried. This 
is the interrupt that I need to, in effect propagate locally. Since my 
spi_master and gpio_chip are all functioning now, this is the last step 
to get one of my spi protocol drivers working correctly.

I've been reading up on Documentation/IRQ-domain.txt, but IRQ 
controllers are all new to me and there's a lot for me to learn, so I 
just want to make sure I'm going down the correct path. Is the correct 
method to create an IRQ domain with irq_domain_add_linear() or some 
such? I can figure it out eventually, but if somebody can point me in 
the right direction, it can save me a WHOLE lot of time.

Thanks in advance
Daniel

