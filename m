Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaHNHKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:10:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaHNHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:10:41 -0400
Date: Thu, 14 Aug 2014 09:10:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140814071026.GE16043@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <1407979069-7121-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 06:17:48PM -0700, Andi Kleen wrote:
> v2: Use correct event name in description. Use EVENT() macro.

> +static unsigned bdw_limit_period(struct perf_event *event, unsigned left)
> +{
> +	if ((event->hw.config & 0xffff) ==

I was thinking you should use INTEL_ARCH_EVENT_MASK or something instead
of the raw 0xFFFF there, but that X86_CONFIG() usage is nice too :-)

> +			X86_CONFIG(.event=0xc0, .umask=0x01)) {
> +		if (left < 128)
> +			left = 128;
> +		left &= ~0x3fu;
> +	}
> +	return left;
> +}

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7GDiAAoJEHZH4aRLwOS67SEP/26u7MmWlq8gMzvF7klUvvW4
knwb5GUkUvEYha+egNZHcCm+ZLbIQSYNufhSV0QWYoEp2XfWknQ7BE/2wmUwJe5s
3eKJ2js4wzlXbRKOolShousNnBaNTqO3mMCgqpyT2RrmnvP+GhPjCfmYC4O++yKc
8VnKVPufLqp2Pvg4asXkDQ2kCPEaZkVBshOmPP4bMZrfXUyowB4Fc2tXu4kkDa9F
OMPxOkzPVl6FHSOgiWuEVjz2lOY5Mxm+h4gsWJv5cqHNVLpaGt1Dkzt8DxlNSQTZ
xDGILjJGpWEHo1ipYjR7D3+dKNH7Xf1NPbf0VGA8jZgBn/2mY+FNlL6H45CX+ZDd
esVBvB/e6s8x7tCHkHRVWkUdmP1iCdkcJoBqwp2IF+Fz6um9vfRMoOLCgdj+0JLK
jIFChh1aFSSGNPBATVEQnOEOY5eQmyZQQdylwYun55ttXLOzJ0pkK3yjwyKl5npe
aM2na5z4fbyC7XemdJTrht033MHKt+6BBfkABaopaQtC3ANKN7Tqxt47fnJpZPxH
X+AK324vp3MJqao9B7bq1tUQHYLMS+1FdJU83ep8/Ahnd9g6T/bYUr9b7t7VEte7
BKCCsITaGlF0mvTvBpM3uEswbs81U2SNuT6l/GnnTTW41EoIwyXCZrQ0up2VUKWa
fFs2M5VVeYGeU3tgvEm/
=yrRn
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
