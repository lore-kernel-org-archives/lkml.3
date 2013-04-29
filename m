Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3D2Pxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:53:46 -0400
Received: from mx2.parallels.com ([199.115.105.18]:43848 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3D2Pxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:53:44 -0400
Message-ID: <517E97BE.9070501@parallels.com>
Date: Mon, 29 Apr 2013 19:54:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp> <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp> <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp> <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <517E8EE1.6090306@parallels.com> <0000013e5679080c-d205d4fa-a545-439d-a976-f234f48e1bcc-000000@email.amazonses.com>
In-Reply-To: <0000013e5679080c-d205d4fa-a545-439d-a976-f234f48e1bcc-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:46 PM, Christoph Lameter wrote:
> On Mon, 29 Apr 2013, Glauber Costa wrote:
> 
>> On 04/29/2013 06:59 PM, Christoph Lameter wrote:
>>> The code in kmalloc_index() creates a BUG() and preferentially should
>>> create a compile time failure when a number that is too big is passed to it.
>>>
>>> What is MAX_ORDER on the architecture?
>>
>> Returning NULL is fine, but kmalloc_index currently does not check for
>> MAX_ORDER at all.
> 
> Could easily add that and BUG() on it?
> 
We could, but now I am intrigued by the fact that the patch I sent does
not fix Tetsuo's problem. 8M should be well within MAX_ORDER
