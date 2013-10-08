Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3JHMEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:04:40 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:19162 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JHMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:04:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBAAz0U1JtTO0v/2dsb2JhbAANTIc5uwGCeYE2gxkBAQEEI3ENAQoCAgUMCgQHAgsDAgECAUUGAQwIAQGvK3WSNIEpjiAKgmCBOQOeXo0JgT8
Message-ID: <5253F4D4.7070402@draigBrady.com>
Date: Tue, 08 Oct 2013 13:04:36 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 39/52] tools/perf/build: Automatically build in parallel,
 based on number of CPUs in the syst
In-Reply-To: 1381227082-22039-40-git-send-email-mingo@kernel.org
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 10:02 AM, Ingo Molnar wrote:
> +ifeq ($(JOBS),)
> +  JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)

nproc is probably ubiquitous enough to use now
(available since coreutils 8.1 (end of 2009))

As well as being more concise, it will take
account of offline CPUs etc.

> +  ifeq ($(JOBS),)
> +    JOBS := 1
> +  endif
> +endif
