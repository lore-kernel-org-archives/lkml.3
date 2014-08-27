Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbaH0WVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:21:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52100 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaH0WU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:20:59 -0400
Message-ID: <53FE59B8.5080401@zytor.com>
Date: Wed, 27 Aug 2014 15:20:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 2/2] x86: iosf: Add debugfs support
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com> <1409175640-32426-3-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1409175640-32426-3-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 02:40 PM, David E. Box wrote:
> Allows access to the iosf sideband through debugfs.

This would break if compiled without CONFIG_DEBUGFS support, which is
often a requirement for security reasons.

Please conditionalize this code, and if practical move it to a separate
.c file.

Most drivers also have separate config options to enable their specific
debugfs options.

	-hpa

