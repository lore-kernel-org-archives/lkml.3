Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaJVX4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:56:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52965 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaJVX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:56:18 -0400
Date: Wed, 22 Oct 2014 16:56:14 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: w.danford@electronics-software.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: source file /drivers/base/platform.c
Message-ID: <20141022235614.GF1193@ld-irv-0074>
References: <20141022160955.802aba6dbaeed9f5026600c863362da9.2d1b0160c3.wbe@email22.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022160955.802aba6dbaeed9f5026600c863362da9.2d1b0160c3.wbe@email22.secureserver.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:09:55PM -0700, w.danford@electronics-software.com wrote:
> /**
>  * platform_get_resource - get a resource for a device
>  * @dev: platform device
>  * @type: resource type
>  * @num: resource index
>  */
> struct resource *platform_get_resource(struct platform_device *dev,
> 				       unsigned int type, unsigned int num)
[...]
> As a result I now suggest a more specific definition is desirable.
> The definition of the 'num' is the offset index for the specific
> resource 'type' to be searched for ignoring all others not of this
> 'type'. ... still convoluted.  By example, first resource of 'type'
> is num=0, second resource of 'type' is num=1 even though say they
> may be [1] and [3] in the complete resource array of resource structs.
> 
> Note my example has type IORESOURCE_MEM as members [0] and [2] in the
> arrya.  So to look for [2] it is the second, num = 1, of type
> IORESOURCE_MEM.
> 
> In conclusion this is a documentation issue!

You spent a lot of words to get to this point! Yes, the problem is with
the assumptions you were making, not with the implementation of
platform_get_resource().

AIUI, your latest interpretation is correct. The indexing of resources
is on a per-resource-type basis. So you're requesting the Nth resource
of type M when type=M and num=N.

Feel free to send a proper patch to improve the comments above
platform_get_resource(), if you think that will help the next person to
come across this API.

Brian
