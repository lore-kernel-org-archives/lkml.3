Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbaJCEVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:21:19 -0400
Received: from ozlabs.org ([103.22.144.67]:47703 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaJCEVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:21:17 -0400
Date: Fri, 3 Oct 2014 14:21:15 +1000
From: Anton Blanchard <anton@samba.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v3] powerpc/iommu/ddw: Fix endianness
Message-ID: <20141003142115.34b9be97@kryten>
In-Reply-To: <1411627167-22927-1-git-send-email-aik@ozlabs.ru>
References: <1411627167-22927-1-git-send-email-aik@ozlabs.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

> rtas_call() accepts and returns values in CPU endianness.
> The ddw_query_response and ddw_create_response structs members are
> defined and treated as BE but as they are passed to rtas_call() as
> (u32 *) and they get byteswapped automatically, the data is
> CPU-endian. This fixes ddw_query_response and ddw_create_response
> definitions and use.
> 
> of_read_number() is designed to work with device tree cells - it
> assumes the input is big-endian and returns data in CPU-endian.
> However due to the ddw_create_response struct fix, create.addr_hi/lo
> are already CPU-endian so do not byteswap them.
> 
> ddw_avail is a pointer to the "ibm,ddw-applicable" property which
> contains 3 cells which are big-endian as it is a device tree.
> rtas_call() accepts a RTAS token in CPU-endian. This makes use of
> of_property_read_u32_array to byte swap and avoid the need for a
> number of be32_to_cpu calls.
> 
> Cc: stable@vger.kernel.org # v3.13
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reviewed-by: Anton Blanchard <anton@samba.org>
> [aik: folded Anton's patch with of_property_read_u32_array]
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks for updating, looks good. Could we make it clear the bug is
present in 3.13-3.17 with:

Cc: stable@vger.kernel.org # v3.13+

Acked-by: Anton Blanchard <anton@samba.org>

Anton
