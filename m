Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaJGU0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:26:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35799 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbaJGU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:26:18 -0400
X-Sasl-enc: EWl+menmb/XVNY3Q8fmKXBlpr7g6vtIelMeaYbDehgqf 1412713577
Message-ID: <1412713575.11600.4.camel@localhost>
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 07 Oct 2014 22:26:15 +0200
In-Reply-To: <20141007.161832.453892039501955243.davem@davemloft.net>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be>
	 <20141007.161832.453892039501955243.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 2014-10-07 at 16:18 -0400, David Miller wrote:
> From: Fabian Frederick <fabf@skynet.be>
> Date: Tue,  7 Oct 2014 22:16:36 +0200
> 
> > static values are automatically initialized to NULL
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> Isn't there some implementation room given to compilers
> as to the representation of true and false?

No, the standard requests implementations to implement false as 0 and
true as 1.

In case of assignments e.g. INT_MAX to _Bool (=bool) it will implicitly
converted to 1, so one can omit the often used !! with booleans.

Bye,
Hannes



