Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaE2Szf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:55:35 -0400
Received: from canardo.mork.no ([148.122.252.1]:43029 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaE2Sze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:55:34 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] usb: gadget: NCM: RX function support multiple NDPs
Organization: m
References: <jim_baxter@mentor.com>
	<1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
	<1401383543-10181-2-git-send-email-jim_baxter@mentor.com>
Date: Thu, 29 May 2014 20:55:16 +0200
In-Reply-To: <1401383543-10181-2-git-send-email-jim_baxter@mentor.com> (Jim
	Baxter's message of "Thu, 29 May 2014 18:12:21 +0100")
Message-ID: <87d2ewbejv.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Baxter <jim_baxter@mentor.com> writes:

> The NDP was ignoring the wNextNdpIndex in the NDP which
> means that NTBs containing multiple NDPs would have missed
> frames.

Well, just for the record: I believe this field was meant to be reserved
and always 0 in the CDC NCM spec.  Table 3-3, describing 16bit NDPs,
says so.  But reading the spec now, I noticed that there is an
inconsistency between table 3-3 and table 3-4 describing 32bit NDPs.  It
looks like the field is not reserved in the 32bit version.

I am pretty sure that is a specification error, but I guess it doesn't
harm to implement the support anyway.  And it paves the way for an MBIM
gadget :-)




Bjørn
