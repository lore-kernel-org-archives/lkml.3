Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaBZN3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:29:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:51745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaBZN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:29:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Date: Wed, 26 Feb 2014 14:29:06 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <d97712e037ea4c90e9cb30c56229383d257831de.1393385236.git.josh@joshtriplett.org>
In-Reply-To: <d97712e037ea4c90e9cb30c56229383d257831de.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261429.06553.arnd@arndb.de>
X-Provags-ID: V02:K0:MoHps+a93M4Vq1hTeBysxW2B71SGW2dC5xJDo4Ft5Nz
 QB1xUYAEJ4Ru2bjULfn165KwKmPLQ3KBxqMaP5d4D6FTDVi701
 sP+7PdgioXYlmAmYJ49KCofm00waxx6f7NRs5pHequngDOG2jm
 fNsPxuJ02czJ6ALmj/Wg9lVICzjzDPiAx9hNwlcUJAIBYaL16l
 hewSuttmfz5cvJJV0aLgG0OMN0rWWIKn6gFi2gHd3Xs+qs1e12
 wFWAeq/0htU0e35zTKYpVQQ8WoaZazPx9+4G7DuJ4XVT5rvqJ3
 eTzVAREhqeml8RZI/zcxDjFdqZr9h0kLem5+Is6FBHeT1KiKpJ
 G66lA3vLOSZk5LOEPMco=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Josh Triplett wrote:
> @@ -134,7 +134,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  
>  #else /* !CONFIG_BUG */
>  #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while (0)
> +#define BUG() do { unreachable(); } while (0)
>  #endif

I disagree with this one. As Alan said, we really want to use an
arch specific BUG() even in the !CONFIG_BUG case.

For the cases where this is not yet possible, I'd suggest using

#define BUG() do { } while (1)


For older gcc versions, this is actually the same as unreachable(), but
it is not the same as __builtin_unreachable, because it causes undefined
behavior.

	Arnd
