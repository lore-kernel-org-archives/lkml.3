Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3H3NA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:00:27 -0400
Received: from nm26-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.115.217]:39561
	"EHLO nm26-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab3H3NAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:00:25 -0400
X-Yahoo-Newman-Id: 736872.1836.bm@smtp105.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Dv5dBT4VM1leindp7iKstWOXpBtMkrlc3Sj3h2Y03zXdbz5
 Pga9i.RrwF5J2Sg8ZGoVwcNrKG7NL5cKbUkF8ALHFF_ek.rmO2t9hCx8Cp5v
 BKZpK9kxioLufXemcN3yab6p537Y3.1upPayKUzT7Rqj3yBi.ipQiTZ8G1yA
 iTKJEcJr2_khcRcaSclkXmlO9O5USbAA9fMfUsJnVUVxg4lvB8bmlmuWk3iq
 eiWiW_QSZJJleef_cNR1vpjd6A6R.rYCRwE8M4pvGJ3vmY850gLUsqRpn2xu
 rOxfm3gGHMVSkxZbnCGaEoRSR2Zk41Vc4_fNeqUf1ps53OlW1EMM7KFcYSk.
 bx2jFrVmkSNJGhtyBzEd9U5uOp9TxBeQ07ot2mEsehGg_don2mrZWwCi7D6u
 plPOcsmDWBR8oJCmA54kKxW8bGOHcKIJrxtOuHUAq5PbUWQH8356aTBdCSbB
 heYy4.weozW3A7xeTuePk6cPJKySj9RQ7vctQ4r.Im43thBi.RKkl7Pj7xYF
 XdpTYoj_nApoqNHrEZFWXbT58JFDspV.LZMbiza.KOmrPcNdMd5S8TzYS4PG
 4XxoQfBuGmuLdawqam4TI4oPAWO4y02LkMlncT1DCnM6IVRk8OQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp105.sbc.mail.bf1.yahoo.com with SMTP; 30 Aug 2013 06:00:24 -0700 PDT
Message-ID: <52209775.7020206@att.net>
Date: Fri, 30 Aug 2013 08:00:37 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>
Subject: USB-to-SPI bridge to spi protocol driver w/ interrupts?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm near being finished with my MCP2210 driver (a USB-to-SPI bridge 
with GPIOs) and have started writing an spi protocol driver for one of 
the devices I'll be talking to, the ADNS-9800.  However, this device has 
an interrupt output pin and I can't figure out how to communicate that 
interrupt from the MCP2210 driver to the ADNS-9800 driver.

If the ADNS-9800 were on the same board as the rest of my computer, I 
would just attach this to an interrupt line, but USB is not an 
interrupt-driven interface.  So in the MCP2210 driver, I poll the device 
and am aware of when these interrupts occur on the remote board (the 
MCP2210 actually has a dedicated interrupt counter functionality), but 
how do deal with this on the host? Should I create a softirq? If so, 
where is this documented? Or should I use some other mechanism?

I hope this isn't a situation where there isn't yet a framework in place 
to do this cleanly.  I'm guessing that these cheap "bridge" types of 
chips will become more popular over time, so running drivers on a host 
computer that communicates with devices on the other side of such 
bridges will become more common in the future as well. They are also 
very nice for prototyping.

My current driver is on github: 
https://github.com/daniel-santos/mcp2210-linux/

Daniel


