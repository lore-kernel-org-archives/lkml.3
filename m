Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbaKMQ6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:58:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245AbaKMQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:58:34 -0500
Message-ID: <5464E336.7020402@redhat.com>
Date: Thu, 13 Nov 2014 17:58:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: memslots: replace heap sort with insertion sort
References: <545BA09E.7040301@redhat.com> <1415896267-2146-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1415896267-2146-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/11/2014 17:31, Igor Mammedov wrote:
> memslots is a sorted array, when slot changes in it
> with current heapsort it would take O(n log n) time
> to update array, while using insertion sort like
> algorithm on array with 1 item out of order will
> take only O(n) time.
> 
> Replace current heapsort with custom sort that
> takes advantage of memslots usage pattern and known
> position of changed slot.
> 
> performance change of 128 memslots insersions with
> gradually increasing size (the worst case):
>       heap sort   custom sort
> max:  249747      15654 cycles
> min:  52536       5562 cycles
> with custom sort alg taking 90% less then original
> update time.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 54 +++++++++++++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 24 deletions(-)

Nice!  I think strictly speaking it's not an insertion sort because
insertion sort doesn't use swaps; it's more similar to a bubble sort.
But the code is very readable and we do not need ultimate
performance---we are just trying to avoid doing something stupid.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
