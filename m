Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaATRT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:19:58 -0500
Received: from one.firstfloor.org ([193.170.194.197]:52364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaATRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:19:54 -0500
Date: Mon, 20 Jan 2014 18:19:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] perf tools: bring back old behavior when
 NO_DEMAGLE doesn't link with libbfd
Message-ID: <20140120171952.GS20765@two.firstfloor.org>
References: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
 <1390217980-22424-4-git-send-email-stfomichev@yandex-team.ru>
 <20140120132225.GA18862@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120132225.GA18862@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 10:22:25AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 20, 2014 at 03:39:40PM +0400, Stanislav Fomichev escreveu:
> > This commit reverts part of the 3e6a147deef9 "perf tools: Separate lbfd
> > check out of NO_DEMANGLE condition" which always links perf with libbfd.
> > I'd like to preserve old behavior when NO_DEMAGLE does not link with
> > it, because some machines may contain different versions of binutils
> > (hence miss required libbfd version) and I still want an option to build perf
> > which works on any machine regardless of binutils version.

BFD is not only used for demangling, it's also used for decoding 
source lines now. So tying it only to NO_DEMANGLE would not be correct.

-Andi
