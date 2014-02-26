Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBZNZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:25:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:62082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZNZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:25:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 1/5] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and family
Date: Wed, 26 Feb 2014 14:24:59 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
In-Reply-To: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261424.59875.arnd@arndb.de>
X-Provags-ID: V02:K0:YSrOJBi3SxI0oFyU+P2aiFu2kGFyFesaqrc6X6cChEX
 jo5TK/QBajQ+UbQzVhP+VYOl9FQtdp0AtNQne1i/RkRDC2kVyI
 Mj6B1FdliKkqv0EXsZo0kU9sB66dRxPDh5tQFkuEBLFJ1KOH4V
 fLPqdfu1sxeWZtlV4V8H0QEPro906YSyJOw3cTEt7cnW50w1wY
 o3PNvzZ6QN8fFSdI9pd55ijCFSFgRbxmLPu4FNrVqjrhr7ZULd
 0e62vh7Q1Tq9LIH1WxcQOxo9CfKW23APLD7FaTeAKNzeba/iuT
 02oDh8NjRkcri5DkhO1fSzRN+N73+Pt7YPtDCLr7zLCZjmPN7L
 TJcVLcpS6MpHnAQ+nAlI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Josh Triplett wrote:
> When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
> condition argument; however, WARN_ON_ONCE and family still have
> conditions and a boolean to detect one-time invocation, even though the
> warning they'd emit doesn't exist.  Make the existing definitions
> conditional on CONFIG_BUG, and add definitions for !CONFIG_BUG that map
> to the passthrough versions of WARN and WARN_ON.
> 
> This saves 4.4k on a minimized configuration (smaller than
> allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
