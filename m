Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaIQANl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:13:41 -0400
Received: from plane.gmane.org ([80.91.229.3]:34370 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbaIQANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:13:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 17:13:23 -0700
Message-ID: <8738brhzoc.fsf@tassilo.jf.intel.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jfdmzpr01-ext.jf.intel.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Cancel-Lock: sha1:O5AhcoJNSaH2R4Lb6CbRieYZ07o=
Cc: linux-api@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Larocque <rlarocque@google.com> writes:

Perhaps I'm missing something, but how do you modify the AUX vector
for the children?
  
> +config VDSO_DISABLE_PRCTL
> +	depends on X86
> +	bool "prctl to disable VDSO loading"
> +	---help---
> +	  Enabling this option adds support for prctl calls that
> +	  set and retrieve a per-process flag to disable VDSO loading on
> +	  exec() for this process and all of its children.

I don't think it makes any sense to have a config for a simple
feature like this. Just do it unconditionally.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

