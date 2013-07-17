Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3GQWHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:07:35 -0400
Received: from science.horizon.com ([71.41.210.146]:45949 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752005Ab3GQWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:07:33 -0400
Date: 17 Jul 2013 18:07:32 -0400
Message-ID: <20130717220732.302.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dhowells@redhat.com
Subject: Re: [PATCH 02/10] Add a generic associative array implementation.
Cc: joe@perches.com, linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to say, the entire boolean type seems strange.  I haven't looked at
all the users, but wouldn't it be better to provide some simple helpers
to allow call sites to set and test lsbits, and document the array as
requiring 2-byte alignment of pointers?

Factoring it into two features like this would eliminate a significant
source of API cruft for callers that don't use the feature, without
cluttering callers that do too much.

And callers could take advantage of known alignment to use more lsbits
if they wanted to.
