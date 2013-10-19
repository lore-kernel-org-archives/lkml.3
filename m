Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3JSWaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:30:13 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:50197 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3JSWaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:30:12 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] vsprintf: add Bluetooth UUID %pU[rR] format specifier
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1382217893.2041.27.camel@joe-AO722>
Date: Sun, 20 Oct 2013 00:30:07 +0200
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <D753FB79-8E82-4F36-881A-68858145B688@holtmann.org>
References: <1382199949-26779-1-git-send-email-marcel@holtmann.org> <1382217893.2041.27.camel@joe-AO722>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

>> The Bluetooth UUID is used in big endian reversed order. Add new
>> modifier to print a UUID in big endian, but where the input byte
>> stream is actually in reversed order.
>> This is similar to %pMR that allows to print a MAC address in
>> reversed order since that is how the Bluetooth BD_ADDR is
>> actually represented in a byte stream.
> 
> Seems sensible.  Other than print_bt_uuid, is
> there another place where will it be used?
> 
> Are you going to convert print_bt_uuid to use this?

my plan is to convert this one when this modifier gets upstream.

>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
>> @@ -1106,6 +1106,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>> 	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
>> 	const u8 *index = be;
>> 	bool uc = false;
>> +	bool reversed = false;
>> 
>> 	switch (*(++fmt)) {
> 
> Could there ever be a little endian reversed UUID?

I honestly do not know. I looked at the little endian one and it looked a bit heavy misplaced if we would use a reversed stream of bytes.

> Might it be useful to change this to:
> 
> 	while (isalpha(*++fmt)) {
> 		switch (*fmt) {

I didn't do it so the modifier didn't get any longer than it needs to be.

Regards

Marcel

