Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3GYPbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:31:48 -0400
Received: from smtp-out-039.synserver.de ([212.40.185.39]:1045 "EHLO
	smtp-out-037.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755892Ab3GYPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:31:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13346
Message-ID: <51F14513.5030200@metafoo.de>
Date: Thu, 25 Jul 2013 17:32:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de> <51F13CEB.7030408@metafoo.de> <51F1404B.7070207@linutronix.de>
In-Reply-To: <51F1404B.7070207@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:12 PM, Sebastian Andrzej Siewior wrote:
> On 07/25/2013 04:57 PM, Lars-Peter Clausen wrote:
>> I'm not sure that this will work. Once you've submitted the descriptor it is
>> owned by the dmaengine driver and you are not allowed to dereference it
>> anymore since the dmaengine driver might free the memory at any time. You
>> should only reference the descriptor by the cookie returned by submit().
> 
> I see. But it can't be reused before calling the callback if it is
> going to call the callback, right?
> So if this is a no-no, I'm left with an additional argument to the
> complete callback?

Hm, maybe using dmaengine_tx_status() and checking the residue field of the
state struct. transferred is basically len - residue.

