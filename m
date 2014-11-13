Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbaKMRqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:46:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60363 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbaKMRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:46:08 -0500
Message-ID: <5464EE5C.8090904@ti.com>
Date: Thu, 13 Nov 2014 11:46:04 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Dave Gerlach <d-gerlach@ti.com>
Subject: Re: [PATCHv2] rpmsg: compute number of buffers to allocate from vrings
References: <1410892387-30596-1-git-send-email-s-anna@ti.com>
In-Reply-To: <1410892387-30596-1-git-send-email-s-anna@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 09/16/2014 01:33 PM, Suman Anna wrote:
> The buffers to be used for communication are allocated during the
> rpmsg virtio driver's probe, and the total number of buffers is
> currently hard-coded to 512. The vring configuration can vary from
> one platform to another or between different remote processors. The
> setup of the receive buffers will throw a WARN_ON if the associated
> vrings are configured with less than 256 buffers (in each direction).
> So, adjust this hard-coded value to rely on the number of buffers the
> virtqueue vring is setup with, but also limit to use 256 buffers at
> most in each direction to avoid wacky resource tables consuming up
> unreasonable memory.
> 
> NOTE: The number of buffers is already assumed to be symmetrical
> in each direction, and that logic is not unchanged.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
> v2 changes:
> - add upper limit on buffers and update comments
> - revise patch description

Any comments on this one, if not can you pick this up for 3.19?

regards
Suman

