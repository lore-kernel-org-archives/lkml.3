Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3CAKlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:41:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51645 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3CAKlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:41:50 -0500
Message-ID: <513085EA.8070007@arm.com>
Date: Fri, 01 Mar 2013 10:41:46 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pawel Moll <Pawel.Moll@arm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
References: <87wqubkalj.fsf@rustcorp.com.au> <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 01 Mar 2013 10:41:47.0355 (UTC) FILETIME=[5FB752B0:01CE1669]
X-MC-Unique: 113030110414803201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/13 10:54, Pawel Moll wrote:
> To solve the never-ending confusions between hosts and guests
> of different endianess, define all virtio-mmio registers as LE.
> 
> This change should be safe at this stage, because no known
> working mixed-endian system exists so there is virtually no
> risk of breaking compatibility.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  virtio-spec.lyx |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/virtio-spec.lyx b/virtio-spec.lyx
> index 1ba9992..a00b675 100644
> --- a/virtio-spec.lyx
> +++ b/virtio-spec.lyx
> @@ -56,6 +56,7 @@
>  \html_math_output 0
>  \html_css_as_file 0
>  \html_be_strict false
> +\author -875410574 "Pawel Moll" 
>  \author -608949062 "Rusty Russell,,," 
>  \author -385801441 "Cornelia Huck" cornelia.huck@de.ibm.com
>  \author 1112500848 "Rusty Russell" rusty@rustcorp.com.au
> @@ -1850,6 +1851,17 @@ struct vring {
>  
>  \begin_layout Subsection
>  A Note on Virtqueue Endianness
> +\change_inserted -875410574 1360838374
> +
> +\begin_inset CommandInset label
> +LatexCommand label
> +name "sub:Virtqueue-Endianness"
> +
> +\end_inset
> +
> +
> +\change_unchanged
> +
>  \end_layout
>  
>  \begin_layout Standard
> @@ -9850,8 +9862,24 @@ a
>  \end_layout
>  
>  \begin_layout Standard
> +
> +\change_deleted -875410574 1360838214
>  The endianness of the registers follows the native endianness of the Guest.
> - Writing to registers described as 
> +\change_inserted -875410574 1360838930
> +All register values are organized as Little Endian, similarly to the PCI
> + variant, see also 
> +\begin_inset CommandInset ref
> +LatexCommand ref
> +reference "sub:Virtqueue-Endianness"

Shouldn't we exclude the config space? PCI defines it as guest-endian,
and the above tends to indicate that it should be LE with MMIO.

	M.
-- 
Jazz is not dead. It just smells funny...

