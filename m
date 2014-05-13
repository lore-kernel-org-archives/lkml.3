Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaEMQ3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:29:19 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37518 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbaEMQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:29:16 -0400
Message-ID: <53724826.9000907@st.com>
Date: Tue, 13 May 2014 18:28:22 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
Cc: <patches@linaro.org>, <linaro-kernel@lists.linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>
Subject: Re: [PATCH] serial: st-asc: Fix data corruption during long console
 bursts
References: <1399997337-27950-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1399997337-27950-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_05:2014-05-13,2014-05-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 05/13/2014 06:08 PM, Daniel Thompson wrote:
> On my test platform (B2020/STiH416) the serial port issues bad characters
> during the initial message avalanche as the console comes up. The problem
> also occurs when dense(ish) I/O is done using the polled I/O interface.
>
> The problem is fixed for me by using the FIFO half-empty bit rather than
> FIFO full bit. Note that using the half-empty bit causes the FIFO to be
> managed in a similar way to interrupt based I/O (i.e. where the hardware
> gets best test coverage).
>
> Running the FIFO half full will have no impact (good or bad) on console
> performance. The UART will still remain fully saturated and the busy-wait
> until the FIFO is empty in asc_console_write() will complete at the same
> time.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>   drivers/tty/serial/st-asc.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks!
Maxime
