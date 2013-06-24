Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3FXWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:47:21 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59446 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FXWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <51C820E7.6040004@cogentembedded.com>
References: <1372055628-27044-1-git-send-email-wedsonaf@gmail.com>
	<51C820E7.6040004@cogentembedded.com>
Date: Mon, 24 Jun 2013 15:47:18 -0700
Message-ID: <CANeycqrPeBvOQeSmRZGcJwCvW=W=Hr+QW8O-99TB_Cqpv5Qr_Q@mail.gmail.com>
Subject: Re: [PATCH v2] [NET]: Unmap fragment page once iterator is done
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The summary line of the original commit is "[NET]: Zerocopy sequential
reading of skb data".

On Mon, Jun 24, 2013 at 3:35 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 24-06-2013 10:33, Wedson Almeida Filho wrote:
>
>> Callers of skb_seq_read() are currently forced to call
>> skb_abort_seq_read()
>> even when consuming all the data because the last call to skb_seq_read
>> (the
>> one that returns 0 to indicate the end) fails to unmap the last fragment
>> page.
>
>
>> With this patch callers will be allowed to traverse the SKB data by
>> calling
>> skb_prepare_seq_read() once and repeatedly calling skb_seq_read() as
>> originally
>> intended (and documented in the original commit 677e90eda), that is, only
>> call
>
>
>    Please also specify the summary line of that commit.
>
>
>> skb_abort_seq_read() if the sequential read is actually aborted.
>
>
>> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
>
>
> WBR, Sergei
>
