Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbaHYUig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbaHYUif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:38:35 -0400
Message-ID: <53FB9EBF.1050108@redhat.com>
Date: Mon, 25 Aug 2014 22:38:23 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com> <20140825203535.GA2038@p183.telecom.by>
In-Reply-To: <20140825203535.GA2038@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 10:35 PM, Alexey Dobriyan wrote:
> On Mon, Aug 25, 2014 at 10:01:39PM +0200, Daniel Borkmann wrote:
>> +void memzero_explicit(void *s, size_t count)
>> +{
>> +	memset(s, 0, count);
>> +	OPTIMIZER_HIDE_VAR(s);
>> +}
>
> BSD seems to name it explicit_bzero().

Sure, that's what I wrote in the commit log. But we don't have
bzero(), and I think the name is more clear and conform to
mem*() API.

Best,

Daniel
