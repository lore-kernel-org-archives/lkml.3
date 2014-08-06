Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaHFKSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:18:43 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:10401 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbaHFKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:18:42 -0400
X-IronPort-AV: E=Sophos;i="5.01,811,1400018400"; 
   d="scan'208";a="88459355"
Date: Wed, 6 Aug 2014 12:18:14 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
cc: Joe Perches <joe@perches.com>
Subject: staging/rtl8192[eu]
Message-ID: <alpine.DEB.2.10.1408061213340.2349@hadrien>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is anyone actually interested in the files:

drivers/staging/rtl8192e/rtllib_softmac.c
drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c

Both contain the following code:

        if (param->u.wpa_ie.len > MAX_WPA_IE_LEN ||
           (param->u.wpa_ie.len && param->u.wpa_ie.data == NULL))
                return -EINVAL;

and

       if (param->u.crypt.alg != NULL) {
                memcpy(sec.keys[param->u.crypt.idx],
                       param->u.crypt.key,
                       param->u.crypt.key_len);

In each case, the NULL test has a trivial result, because the requested
field is an array inlined within a structure.  In the first case, the
array has size 0, so I guess the intent is to see whether some more space
has been allocated, and in the second case the array contains a string, so
I guess the intent is to see whether something has been stored in the
string.  But I don't know how it is intended to do either operation.

julia
