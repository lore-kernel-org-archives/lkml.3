Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3CNL6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:58:04 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51425 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab3CNL6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:58:02 -0400
Message-ID: <5141BB44.2020902@gmail.com>
Date: Thu, 14 Mar 2013 15:57:56 +0400
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com> <1363224194-7366-1-git-send-email-ynvich@gmail.com> <CAKYAXd_v5TsMJ+h3Zk4FRDB0jAfF04t4Z65D1kmB1ziOk65+Vg@mail.gmail.com>
In-Reply-To: <CAKYAXd_v5TsMJ+h3Zk4FRDB0jAfF04t4Z65D1kmB1ziOk65+Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 08:08, Namjae Jeon wrote:> 2013/3/14, Sergey Yanovich <ynvich@gmail.com>:
>> Kernel panic - not syncing: VFS: Unable to mount root fs on
>> unknown-block(0,0)

> Have you ever tried to use rootwait or rootdelay on command line ?
> If no, You can use them.

Those options work. However, they introduce a delay in the range of hundreds milliseconds and seconds respectively. They delay is not required. If a cards is present, mmc_rescan will return synchronously with card initialized.

prepare_namespace() uses wait_for_device_probe(). The latter assumes that all "known devices" have initialized by the time it returns. MMC is not currently delivering on the assumptions. It will with the patch applied.
