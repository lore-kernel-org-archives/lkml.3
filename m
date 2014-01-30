Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaA3Qw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:52:56 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60052 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaA3Qwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:52:54 -0500
MIME-Version: 1.0
Date: Thu, 30 Jan 2014 08:52:54 -0800
Message-ID: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com>
Subject: [BUG] Description for memmap in kernel-parameters.txt is wrong
From: Andiry Xu <andiry@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andiry Xu <andiry.xu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In kernel-parameters.txt, there is following description:

memmap=nn[KMG]$ss[KMG]
                        [KNL,ACPI] Mark specific memory as reserved.
                        Region of memory to be used, from ss to ss+nn.

Unfortunately this is incorrect. The meaning of nn and ss is reversed.
For example:

Command                  Expected                 Result
memmap 2G$6G        6G - 8G reserved      2G - 8G reserved
memmap 6G$2G        2G - 8G reserved      6G - 8G reserved

Test kernel version 3.13, but I believe the issue has been there long ago.

I'm not sure whether the description or implementation should be
fixed, but apparently they do not match.

Thanks,
Andiry
