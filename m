Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3LSSyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:54:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53153 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3LSSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:54:08 -0500
Message-ID: <52B340CB.90807@wwwdotorg.org>
Date: Thu, 19 Dec 2013 11:54:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org
CC: Takashi Iwai <tiwai@suse.de>, the arch/x86 maintainers <x86@kernel.org>,
        linux-fbdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86: sysfb: remove sysfb when probing real hw
References: <1387374611-12493-1-git-send-email-dh.herrmann@gmail.com> <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 03:13 AM, David Herrmann wrote:
> With CONFIG_X86_SYSFB=y, probing real hw-drivers may result in
> resource-conflicts and drivers will refuse to load. A call to
> request_mem_region() will fail, if the region overlaps with the mem-region
> used by simplefb. The common desktop DRM drivers (intel, nouveau, radeon)
> are not affected as they don't reserve their resources, but some others
> do, including (nvidiafb, cirrus, ..).

I have validated that this doesn't cause any regressions on the/a
non-x86 platform using simplefb, although given the main point of this
patch is to fix issues on x86, I'm rather hesitant to give a tested-by
tag in case someone looking back interprets it incorrectly:-)
