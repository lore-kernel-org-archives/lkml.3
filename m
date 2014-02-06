Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaBFVvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:51:19 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:52916 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaBFVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:51:18 -0500
MIME-Version: 1.0
In-Reply-To: <52F3FFBC.1010505@redhat.com>
References: <1391685000-7346-1-git-send-email-mq@suse.cz>
	<52F3FFBC.1010505@redhat.com>
Date: Thu, 6 Feb 2014 13:51:16 -0800
Message-ID: <CAHA+R7NFRKU_XDpJT1ZFdx0Rp67qpnwcHw5asAxT_oG8wQTM6A@mail.gmail.com>
Subject: Re: [PATCH] inet: defines IPPROTO_* needed for module alias generation
From: Cong Wang <cwang@twopensource.com>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: Jan Moskyto Matejka <mq@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 1:33 PM, Carlos O'Donell <carlos@redhat.com> wrote:
> On 02/06/2014 06:10 AM, Jan Moskyto Matejka wrote:
>> Reverting this change back to define's to fix the aliases.
>>
>> modinfo mip6 (before this change)
>> alias:          xfrm-type-10-IPPROTO_DSTOPTS
>> alias:          xfrm-type-10-IPPROTO_ROUTING
>>
>> modinfo mip6 (after this change)
>> alias:          xfrm-type-10-43
>> alias:          xfrm-type-10-60
>
> Instead of reverting these changes I suggest someone fix
> whatever is processing that information.

It is stringfy by c preprocessor. enum should be processed
after preprocessing, therefore fails to be converted to it
real value at preprocessing stage.
