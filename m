Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3IEDwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:52:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3IEDwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:52:43 -0400
Message-ID: <5227FFE8.5050102@zytor.com>
Date: Wed, 04 Sep 2013 20:52:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module security
 is enabled
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 04:50 PM, Matthew Garrett wrote:
> IO port access would permit users to gain access to PCI configuration
> registers, which in turn (on a lot of hardware) give access to MMIO register
> space. This would potentially permit root to trigger arbitrary DMA, so lock
> it down by default.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Seriously... just deny CAP_SYS_RAWIO to any system in secure mode.

	-hpa


