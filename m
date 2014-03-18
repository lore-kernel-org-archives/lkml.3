Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaCRIeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:34:06 -0400
Received: from canardo.mork.no ([148.122.252.1]:47799 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaCRIeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:34:01 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Chan <benchan@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: Re: [PATCH v3 2/2] net: cdc_ncm: respect operator preferred MTU reported by MBIM
Organization: m
References: <1395115145-31821-1-git-send-email-benchan@chromium.org>
	<1395115145-31821-2-git-send-email-benchan@chromium.org>
Date: Tue, 18 Mar 2014 09:33:40 +0100
In-Reply-To: <1395115145-31821-2-git-send-email-benchan@chromium.org> (Ben
	Chan's message of "Mon, 17 Mar 2014 20:59:05 -0700")
Message-ID: <871txzlxcr.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Chan <benchan@chromium.org> writes:

> According to "Universal Serial Bus Communications Class Subclass
> Specification for Mobile Broadband Interface Model, Revision 1.0,
> Errata-1" published by USB-IF, the wMTU field of the MBIM extended
> functional descriptor indicates the operator preferred MTU for IP data
> streams.
>
> This patch modifies cdc_ncm_setup to ensure that the MTU value set on
> the usbnet device does not exceed the operator preferred MTU indicated
> by wMTU if the MBIM device exposes a MBIM extended functional
> descriptor.
>
> Signed-off-by: Ben Chan <benchan@chromium.org>
> ---
> Patch v3 (which is same as v2) adds the le16_to_cpu conversion on
> ctx->mbim_extended_desc->wMTU as pointed out and suggested by
> 'Bjørn Mork <bjorn@mork.no>'.

Looks good to me FWIW.

I was worried that I might have created a merge conflict here by posting
the unrelated cdc_ncm fix, touching the same function.  But we're in
luck: That fix and your patch applies cleanly on top of each other in
any order.


Bjørn
