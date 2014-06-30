Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaF3QQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:16:32 -0400
Received: from shell.v3.sk ([195.168.3.45]:60622 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbaF3QQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:16:30 -0400
Message-ID: <1404144980.6148.6.camel@hobbes>
Subject: Re: [PATCHv7 0/5] Common Mailbox Framework
From: Lubomir Rintel <lkundrak@v3.sk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mporter@linaro.org, patches@linaro.org, bjorn@kryo.se,
        ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, pa@jasper.es
Date: Mon, 30 Jun 2014 18:16:20 +0200
In-Reply-To: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-22.el7_0.1) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On Thu, 2014-06-12 at 22:28 +0530, Jassi Brar wrote:
> Hello,
>   Here is the next revision of Mailbox framwork.

I'm wondering whether you keep a Git tree with the framework we could
keep the Raspberry Pi mailbox driver based on (bcm2835-mbox)?

Also, from look at the API it does not seem to me that it's possible to
synchronously (that is without a tx_done callback) collect a response
when a message is sent with tx_block enabled. Equivalent to this: [1]

	bcm_mailbox_write(MBOX_CHAN_FB, vc4->mode_set_cmd_addr);
	bcm_mailbox_read(MBOX_CHAN_FB, &val);

[1] https://github.com/anholt/linux/commit/d6276826c1e94d942bd9f9dd4586b52197f13fb7#diff-fe03b88eaabd67668dcf9e116346793fR184

What's your opinion on that?

Regards,
Lubo

