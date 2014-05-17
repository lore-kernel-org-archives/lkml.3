Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaEQMRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:17:06 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54514 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaEQMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:17:03 -0400
Message-ID: <53775334.3030704@gmail.com>
Date: Sat, 17 May 2014 14:16:52 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property
 'dependencies' which contains a list of referenced phandles
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <1399913280-6915-2-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1399913280-6915-2-git-send-email-holler@ahsoftware.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 12.05.2014 18:47, Alexander Holler wrote:
> During the step from .dts to .dtb the information about dependcies contained
> in the .dts through phandle references is lost. This makes it impossible to
> use the binary blob to create a dependency graph without knowing the semantic
> of all cell arrays.
> 
> Therefor automatically add a new property called 'dependencies' to all nodes
> which have phandle references in one of their properties.
> 
> This new property will contain an array of phandles with one value for every
> phandle referenced by other properties in the node.
> 
> If such a property already exists (e.g. to manually add dependencies through
> the .dts), the existing list will be expanded.
> 
> Added phandles will be the phandle of either the referenced node itself (if
> it has a property named 'compatible', or of the next parent of the referenced
> node which as property named 'compatible'. This ensures only dependencies to
> drivers will be added.
> 

Sounds good.

> References to phandles of parent or child nodes will not be added to this
> property, because this information is already contained in the blob (in the
> form of the tree itself).

I wonder if we shouldn't be including them too for consistency related
reasons, so we have all the necessary information in one place.
References to child nodes are great recipes for cycles, though...

No strong opinion, though, just an idea.

> 
> No dependencies to disabled nodes will be added.
> 

Same here. IMHO it might be wise to let the parsing entity (e.g. kernel)
decide whether to ignore a dependency to disabled node or not.

Otherwise, I like the simplicity of compile-time dependency list
creation. Quite a nice work.

Best regards,
Tomasz
