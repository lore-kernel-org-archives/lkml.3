Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3K1DcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:32:03 -0500
Received: from [213.199.154.188] ([213.199.154.188]:55770 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754154Ab3K1Db7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:31:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzc89bh1433M1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h1155h)
Message-ID: <5296B9C5.3060704@freescale.com>
Date: Thu, 28 Nov 2013 11:34:29 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <angus.clark@st.com>, <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org> <20131127040723.GZ9468@ld-irv-0074.broadcom.com> <20131127115226.GC3296@lee--X1>
In-Reply-To: <20131127115226.GC3296@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年11月27日 19:52, Lee Jones 写道:
> However, as we send entire 'message sequences' to the FSM Controller
> as opposed to merely OPCODEs we would have to extract the OPCODE from
> flash->command[0] and call our own functions to craft the correct
> 'message sequence' for the task. For this reason we rejected the idea
> and went with a stand-alone driver.
>
could you send me the datasheet of your spi nor controller?
I can change my code if it really not good enough.

we can store the opcode to a field, such as spi_nor_write_op.
> The framework which Huang is proposing suffers from the same issues.
> Only providing read(), write(), read_reg() and write_reg() doesn't
> work for our use-case, as we'd have to decode the flash->command[0] and
> invoke our own internal routines as before.
>
> The only framework with would work for us would consist almost all
> of the important functions such as; read(), write(), erase(),
> wait_busy(), read_jedec(), read_status_reg(), write_status_reg(),
> read_control_reg(), write_control_reg(), etc. However, this approach
>   
read_jedec() can be replaced by read_reg(0x9f);

read_status() can be replaced by read_reg(0x5);

....

write_control_reg() can be replaced by write_reg(xx).


Please correct me if i am wrong.

IMHO, the current four hooks for spi-nor{} can do all the things.

      read/write/read_reg/write_reg.

thanks
Huang Shijie









