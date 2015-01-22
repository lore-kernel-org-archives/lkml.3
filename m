Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbbAVUX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:23:56 -0500
Received: from mailrelay2.public.one.com ([91.198.169.125]:11415 "EHLO
	mailrelay2.public.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbAVUXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:23:54 -0500
X-HalOne-Cookie: 4fb5508177010d5160eeced32d3ce7fd83177d4b
X-HalOne-ID: 93fb7a26-a274-11e4-919b-b82a72d03b9b
Message-ID: <54C15C61.9000100@bitmath.org>
Date: Thu, 22 Jan 2015 21:24:01 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: MT - Add support for balanced slot assignment
References: <1421956345-1546-1-git-send-email-rydberg@bitmath.org> <20150122200252.GE18153@dtor-ws>
In-Reply-To: <20150122200252.GE18153@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 01/22/2015 09:02 PM, Dmitry Torokhov wrote:
> On Thu, Jan 22, 2015 at 08:52:25PM +0100, Henrik Rydberg wrote:
>>  int input_mt_assign_slots(struct input_dev *dev, int *slots,
>> -			  const struct input_mt_pos *pos, int num_pos)
>> +			  const struct input_mt_pos *pos, int num_pos,
>> +			  int dmax)
> 
> Should dmax be unsigned and do we really need to treat 0 specially or we
> could use UNIT_MAX as "don't care" value?

We could have dmax unsigned, but it does not have to be from a branching
perspective, since the square is what gets used anyways.

>>  {
>>  	struct input_mt *mt = dev->mt;
>> +	int mu = 2 * dmax * dmax;
> 
> For my education, what does "mu" stand for?

I chose mu because of the mathematical similarity to the chemical potential in
statistical mechanics, where it denotes the energy per particle. Here, it
denotes the energy per contact assignment.

> Ideally, if someone could create a
> write-up on the contact matching that would be most awesome.

Heh, I guess I will have to write something at some point, without requiring
prior knowledge of Lagrange relaxation or the like. Time is a luxury these days...

Henrik

