Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3D2Lna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:43:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3D2Ln3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:43:29 -0400
Message-ID: <1367235801.4656.66.camel@marge.simpson.net>
Subject: Re: perf: report loops endlessly if record was killed via SIGTERM
From: Mike Galbraith <bitbucket@online.de>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, 29 Apr 2013 13:43:21 +0200
In-Reply-To: <517E5905.1070700@gmail.com>
References: <1367222415.4656.61.camel@marge.simpson.net>
	 <517E5905.1070700@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kLxsZOvOutBVUiNBaspEZhqPQk3siz5fcaA4c9S3u0c
 8XrXGrP+JCeQwaX28E63IVsguvDdJQailXwZArPC+prADY+Du6
 z9gWLUuSVFU76ACAxvuojF2v9S3SCBJqRIFCsFn1+Fzs8Od7v2
 tJc5dZ6wiun4Ww8ahU4aSl6Y0tztjjciNz156SXrphwCQkocZg
 upOQTkRIzHWn1juBGY1uudI4QegVA2JujF85L36iA2ifKBUwHv
 oDMRl/tVsSOlbvWmoNG1IkV67vyt5ysQiUXofbtrmGORcZUQCs
 q3XYHLaGrQPy9WgwX/nKe9zyoGd+T6nxAgNeB9m2Skf9PJTfGX
 f8Ow7E/CH2VXSENw0qTCutVzT/l4GVfzI0XHVMfdL7fy/IojAi
 cTw4aV4jAOBMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 07:27 -0400, David Ahern wrote: 
> On 4/29/13 4:00 AM, Mike Galbraith wrote:
> > Say SIGINT instead,
> > and it works as expected.  SIGTERM leaves perf.data in a bad state that
> > report can't deal with, but it'll happily keep trying forever.
> 
> header is usually updated on_exit which requires a clean exit. perhaps 
> we should add SIGTERM to the signal list.

Yeah.  Graceful exit, and idiot proofing for free :)

-Mike

