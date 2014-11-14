Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161761AbaKNUDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:03:43 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42174 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaKNUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <54660C93.6050801@st.com>
References: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com>
	<20141113140936.e2e45a8970b5bb4195fd5065@linux-foundation.org>
	<54660C93.6050801@st.com>
Date: Fri, 14 Nov 2014 23:03:40 +0300
Message-ID: <CAMo8BfJHpoZvWxxo0axAoEDaObeQehSS4CzWoPxBG0520Hb44A@mail.gmail.com>
Subject: Re: [PATCH v4] bitops: Fix shift overflow in GENMASK macros
From: Max Filippov <jcmvbkbc@gmail.com>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux@rasmusvillemoes.dk,
        gong.chen@linux.intel.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, kernel@stlinux.com,
        eric.paire@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Fri, Nov 14, 2014 at 5:07 PM, Maxime Coquelin <maxime.coquelin@st.com> wrote:
> Looking at all GENMASK and GENMASK_ULL occurences in v3.18-rc4,
> I (only) found one possible candidate in drivers/spi/spi_xtensa-xtfpga.c:
>
> static u32 xtfpga_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
>                 u32 v, u8 bits)
> {
>     struct xtfpga_spi *xspi = spi_master_get_devdata(spi->master);
>
>     xspi->data = (xspi->data << bits) | (v & GENMASK(bits - 1, 0));
> ...
> }
>
> Max F., can xtfpga_spi_txrx_word() be called with "bits" = 32?

No, bits should never be greater than 16, because spi_master sets its
bits_per_word_mask to SPI_BPW_RANGE_MASK(1, 16).

-- 
Thanks.
-- Max
