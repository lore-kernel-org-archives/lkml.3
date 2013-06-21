Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423182Ab3FUFDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:03:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53588 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670Ab3FUFDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:03:05 -0400
Message-ID: <51C3DDFA.7050204@zytor.com>
Date: Thu, 20 Jun 2013 22:00:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: MTRR use in drivers
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An awful lot of drivers, mostly DRI drivers, are still mucking with
MTRRs directly as opposed to using ioremap_wc() or similar interfaces.
In addition to the architecture dependency, this is really undesirable
because MTRRs are a limited resource, whereas page table attributes are not.

Furthermore, this perpetuates the need for the horrific hack known as
"MTRR cleanup".

What, if anything, can we do to clean up this mess?

	-hpa
