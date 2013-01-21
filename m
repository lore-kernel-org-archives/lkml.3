Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3AUS7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:59:52 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39620 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3AUS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:59:51 -0500
Message-ID: <50FD901C.8000002@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 10:59:40 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/5] fix kvm's use of __pa() on percpu areas
References: <20130121175244.E5839E06@kernel.stglabs.ibm.com> <20130121175250.1AAC7981@kernel.stglabs.ibm.com> <08cba1bf-6476-4fad-8d29-e380ec7127ba@email.android.com>
In-Reply-To: <08cba1bf-6476-4fad-8d29-e380ec7127ba@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012118-5806-0000-0000-00001E8B7448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 10:38 AM, H. Peter Anvin wrote:
> Final question: are any of these done in frequent paths?  (I believe no, but...)

Nope.  All of the places that it gets used here are in
initialization-time paths.  The two we have here are when kvm and the
host are setting up a new vcpu and when the kvmclock clocksource is
being registered.  A CPU getting hotplugged is the only thing that might
even have these get called more than at boot.

