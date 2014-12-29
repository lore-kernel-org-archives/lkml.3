Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaL2Rgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:36:44 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:18250 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaL2Rgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:36:42 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k7AuKiShA==
X-RZG-CLASS-ID: mo00
Message-ID: <54A19123.5040708@hartkopp.net>
Date: Mon, 29 Dec 2014 18:36:35 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heinz-J=FCrgen_Oertel?= <hj.oertel@t-online.de>,
        mkl@pengutronix.de
CC: Aaron Wu <Aaron.wu@analog.com>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bfin_can: move the header file to arch independent location
References: <1419563241-20766-1-git-send-email-Aaron.wu@analog.com> <549E936A.2080904@hartkopp.net> <5234314.TQCbV9cZp1@heinz>
In-Reply-To: <5234314.TQCbV9cZp1@heinz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 05:45 PM, Heinz-Jürgen Oertel wrote:
> Am Samstag, 27. Dezember 2014, 12:09:30 schrieb Oliver Hartkopp:
>> As bfin_can.c is the only user of defines from this include file just add the
>> needed(!) defines directly to bfin_can.c
> 
> I often include also the yet unneeded definitions, e.g., for unused register or unused bit definitions.
> That makes it easier for someone else to add missing functionality, when later on needed.
> 

Yes. This can be useful when you can imagine to add functionality into a
specific direction. But in this case there were tons of mailbox definitions
(always defined 32 times each) which we will not use in this way in the netdev
driver.

Just take a look into bfin_can.h and what is really used in bfin_can.c from
those defines and you will see.

Regards,
Oliver
