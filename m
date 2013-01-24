Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3AXTWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:22:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3AXTV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:21:58 -0500
Date: Thu, 24 Jan 2013 14:21:56 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
Message-ID: <20130124192155.GJ6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <20130124190610.GI6538@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124190610.GI6538@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:06:10PM -0500, Kyle McMartin wrote:
> +	if (err < 0 && fips_enabled && !get_modinfo(info, "crypto_fips"))

Sigh, that should be get_modinfo(...)
	if (err < 0 && fips_enabled && get_modinfo(info, "crypto_fips"))

Thinko when converting from flagging things as "nocrypto" to the above,
since it touches far fewer .ko

--Kyle
