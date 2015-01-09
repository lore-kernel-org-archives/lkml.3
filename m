Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbbAIPmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:42:05 -0500
Received: from smtp-out-098.synserver.de ([212.40.185.98]:1066 "EHLO
	smtp-out-245.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933095AbbAIPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:42:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7736
Message-ID: <54AFF6C4.9020306@metafoo.de>
Date: Fri, 09 Jan 2015 16:41:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: Simplify IIO provider access locking mechanism
References: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:38 PM, Ivan T. Ivanov wrote:
> Instead of checking whether provider module is still
> loaded on every access to device just lock module to
> memory when client get reference to provider device.
>

This has nothing to do with the module, it's about the device. In the Linux 
device driver model as device can be unbound at any time and the IIO 
framework needs to handle this.

- Lars
