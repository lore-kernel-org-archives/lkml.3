Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3HAUmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:42:51 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57332 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3HAUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:42:50 -0400
MIME-Version: 1.0
In-Reply-To: <201308012025.r71KP3le029955@farm-0021.internal.tilera.com>
References: <201308012025.r71KP3le029955@farm-0021.internal.tilera.com>
Date: Fri, 2 Aug 2013 00:42:48 +0400
Message-ID: <CAMo8BfJEG1L125+pTq3Ke0mD__gm8u7mqJxUf9UkPXLpjBgrUg@mail.gmail.com>
Subject: Re: [PATCH] tile: optimize strnlen using SIMD instructions
From: Max Filippov <jcmvbkbc@gmail.com>
To: Ken Steele <ken@tilera.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

On Thu, Aug 1, 2013 at 11:55 PM, Ken Steele <ken@tilera.com> wrote:
> +       /* Read the first word, but force bytes before the string to be nonzero.
> +        * This expression works because we know shift counts are taken mod 32.
> +        */
> +       v = *p | ((1 << (s_int << 3)) - 1);

This expression potentially has undefined behaviour according to C99, 6.5.7:3.
IOW it may work, but it doesn't always have to.

-- 
Thanks.
-- Max
