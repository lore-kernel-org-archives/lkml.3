Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaJBRBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:01:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37104 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaJBRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:01:52 -0400
MIME-Version: 1.0
Date: Fri, 3 Oct 2014 01:01:52 +0800
Message-ID: <CAHkaATTW2T=D+q1wwB7MyMedU2C1nch9-MPkHYW0kODVFfYk3Q@mail.gmail.com>
Subject: [PATCH] slub: fix coding style problems
From: Min-Hua Chen <orca.chen@gmail.com>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix most obvious coding style problems reported by checkpatch.pl -f mm/slub.c

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 mm/slub.c |  121 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 63 insertions(+), 58 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3e8afcc..7ea162f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -93,25 +93,25 @@
  *
  * Overloading of page flags that are otherwise used for LRU management.
  *
- * PageActive         The slab is frozen and exempt from list processing.
- *             This means that the slab is dedicated to a purpose
- *             such as satisfying allocations for a specific
- *             processor. Objects may be freed in the slab while
- *             it is frozen but slab_free will then skip the usual
- *             list operations. It is up to the processor holding
- *             the slab to integrate the slab into the slab lists
- *             when the slab is no longer needed.
+ * PageActive        The slab is frozen and exempt from list processing.
+ *            This means that the slab is dedicated to a purpose
+ *            such as satisfying allocations for a specific
+ *            processor. Objects may be freed in the slab while
+ *            it is frozen but slab_free will then skip the usual
+ *            list operations. It is up to the processor holding
+ *            the slab to integrate the slab into the slab lists
+ *            when the slab is no longer needed.
  *
- *             One use of this flag is to mark slabs that are
- *             used for allocations. Then such a slab becomes a cpu
- *             slab. The cpu slab may be equipped with an additional
- *             freelist that allows lockless access to
- *             free objects in addition to the regular freelist
- *             that requires the slab lock.
+ *            One use of this flag is to mark slabs that are
+ *            used for allocations. Then such a slab becomes a cpu
+ *            slab. The cpu slab may be equipped with an additional
+ *            freelist that allows lockless access to
+ *            free objects in addition to the regular freelist
+ *            that requires the slab lock.
  *
  * PageError        Slab requires special handling due to debug
- *             options set. This moves    slab handling out of
- *             the fast path and disables lockless freelists.
+ *            options set. This moves    slab handling out of
+ *            the fast path and disables lockless freelists.
  */

 static inline int kmem_cache_debug(struct kmem_cache *s)
@@ -230,7 +230,7 @@ static inline void stat(const struct kmem_cache
*s, enum stat_item si)
 }

 /********************************************************************
- *             Core slab cache functions
+ *            Core slab cache functions
  *******************************************************************/

 /* Verify that a pointer has an address that is valid within a slab page */
@@ -355,9 +355,11 @@ static __always_inline void slab_unlock(struct page *page)
     __bit_spin_unlock(PG_locked, &page->flags);
 }

-static inline void set_page_slub_counters(struct page *page, unsigned
long counters_new)
+static inline void set_page_slub_counters(struct page *page,
+                      unsigned long counters_new)
 {
     struct page tmp;
+
     tmp.counters = counters_new;
     /*
      * page->counters can cover frozen/inuse/objects as well
@@ -371,14 +373,14 @@ static inline void set_page_slub_counters(struct
page *page, unsigned long count
 }

 /* Interrupts must be disabled (for the fallback code to work right) */
-static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct
page *page,
-        void *freelist_old, unsigned long counters_old,
-        void *freelist_new, unsigned long counters_new,
-        const char *n)
+static inline bool __cmpxchg_double_slab(struct kmem_cache *s,
+        struct page *page, void *freelist_old,
+        unsigned long counters_old, void *freelist_new,
+        unsigned long counters_new, const char *n)
 {
     VM_BUG_ON(!irqs_disabled());
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
     if (s->flags & __CMPXCHG_DOUBLE) {
         if (cmpxchg_double(&page->freelist, &page->counters,
                    freelist_old, counters_old,
@@ -414,7 +416,7 @@ static inline bool cmpxchg_double_slab(struct
kmem_cache *s, struct page *page,
         const char *n)
 {
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
     if (s->flags & __CMPXCHG_DOUBLE) {
         if (cmpxchg_double(&page->freelist, &page->counters,
                    freelist_old, counters_old,
@@ -550,6 +552,7 @@ static void print_track(const char *s, struct track *t)
 #ifdef CONFIG_STACKTRACE
     {
         int i;
+
         for (i = 0; i < TRACK_ADDRS_COUNT; i++)
             if (t->addrs[i])
                 pr_err("\t%pS\n", (void *)t->addrs[i]);
@@ -708,34 +711,34 @@ static int check_bytes_and_report(struct
kmem_cache *s, struct page *page,
  * Object layout:
  *
  * object address
- *     Bytes of the object to be managed.
- *     If the freepointer may overlay the object then the free
- *     pointer is the first word of the object.
+ *    Bytes of the object to be managed.
+ *    If the freepointer may overlay the object then the free
+ *    pointer is the first word of the object.
  *
- *     Poisoning uses 0x6b (POISON_FREE) and the last byte is
- *     0xa5 (POISON_END)
+ *    Poisoning uses 0x6b (POISON_FREE) and the last byte is
+ *    0xa5 (POISON_END)
  *
  * object + s->object_size
- *     Padding to reach word boundary. This is also used for Redzoning.
- *     Padding is extended by another word if Redzoning is enabled and
- *     object_size == inuse.
+ *    Padding to reach word boundary. This is also used for Redzoning.
+ *    Padding is extended by another word if Redzoning is enabled and
+ *    object_size == inuse.
  *
- *     We fill with 0xbb (RED_INACTIVE) for inactive objects and with
- *     0xcc (RED_ACTIVE) for objects in use.
+ *    We fill with 0xbb (RED_INACTIVE) for inactive objects and with
+ *    0xcc (RED_ACTIVE) for objects in use.
  *
  * object + s->inuse
- *     Meta data starts here.
+ *    Meta data starts here.
  *
- *     A. Free pointer (if we cannot overwrite object on free)
- *     B. Tracking data for SLAB_STORE_USER
- *     C. Padding to reach required alignment boundary or at mininum
- *         one word if debugging is on to be able to detect writes
- *         before the word boundary.
+ *    A. Free pointer (if we cannot overwrite object on free)
+ *    B. Tracking data for SLAB_STORE_USER
+ *    C. Padding to reach required alignment boundary or at mininum
+ *        one word if debugging is on to be able to detect writes
+ *        before the word boundary.
  *
  *    Padding is done using 0x5a (POISON_INUSE)
  *
  * object + s->size
- *     Nothing is used beyond s->size.
+ *    Nothing is used beyond s->size.
  *
  * If slabcaches are merged then the object_size and inuse boundaries
are mostly
  * ignored. And therefore no slab options that rely on these boundaries
@@ -911,14 +914,14 @@ static int on_freelist(struct kmem_cache *s,
struct page *page, void *search)
         max_objects = MAX_OBJS_PER_PAGE;

     if (page->objects != max_objects) {
-        slab_err(s, page, "Wrong number of objects. Found %d but "
-            "should be %d", page->objects, max_objects);
+        slab_err(s, page, "Wrong number of objects. Found %d but should be %d",
+        page->objects, max_objects);
         page->objects = max_objects;
         slab_fix(s, "Number of objects adjusted.");
     }
     if (page->inuse != page->objects - nr) {
-        slab_err(s, page, "Wrong object count. Counter is %d but "
-            "counted were %d", page->inuse, page->objects - nr);
+        slab_err(s, page, "Wrong object count. Counter is %d but
counted were %d",
+        page->inuse, page->objects - nr);
         page->inuse = page->objects - nr;
         slab_fix(s, "Object count adjusted.");
     }
@@ -956,7 +959,8 @@ static void add_full(struct kmem_cache *s,
     list_add(&page->lru, &n->full);
 }

-static void remove_full(struct kmem_cache *s, struct kmem_cache_node
*n, struct page *page)
+static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
+            struct page *page)
 {
     if (!(s->flags & SLAB_STORE_USER))
         return;
@@ -1075,8 +1079,8 @@ static noinline struct kmem_cache_node
*free_debug_processing(

     if (unlikely(s != page->slab_cache)) {
         if (!PageSlab(page)) {
-            slab_err(s, page, "Attempt to free object(0x%p) "
-                "outside of slab", object);
+            slab_err(s, page, "Attempt to free object(0x%p) outside of slab",
+            object);
         } else if (!page->slab_cache) {
             pr_err("SLUB <none>: no slab for object 0x%p.\n",
                    object);
@@ -2469,6 +2473,7 @@ EXPORT_SYMBOL(kmem_cache_alloc);
 void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
     void *ret = slab_alloc(s, gfpflags, _RET_IP_);
+
     trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags);
     return ret;
 }
@@ -2552,7 +2557,7 @@ static void __slab_free(struct kmem_cache *s,
struct page *page,

             } else { /* Needs to be taken off a list */

-                            n = get_node(s, page_to_nid(page));
+                n = get_node(s, page_to_nid(page));
                 /*
                  * Speculatively acquire the list_lock.
                  * If the cmpxchg does not succeed then we may
@@ -2585,10 +2590,10 @@ static void __slab_free(struct kmem_cache *s,
struct page *page,
          * The list lock was not taken therefore no list
          * activity can be necessary.
          */
-                if (was_frozen)
-                        stat(s, FREE_FROZEN);
-                return;
-        }
+        if (was_frozen)
+            stat(s, FREE_FROZEN);
+        return;
+    }

     if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
         goto slab_empty;
@@ -3078,7 +3083,7 @@ static int kmem_cache_open(struct kmem_cache *s,
unsigned long flags)
     }

 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
     if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
         /* Enable fast mode */
         s->flags |= __CMPXCHG_DOUBLE;
@@ -3130,8 +3135,7 @@ static int kmem_cache_open(struct kmem_cache *s,
unsigned long flags)
     free_kmem_cache_nodes(s);
 error:
     if (flags & SLAB_PANIC)
-        panic("Cannot create slab %s size=%lu realsize=%u "
-            "order=%u offset=%u flags=%lx\n",
+        panic("Cannot create slab %s size=%lu realsize=%u order=%u
offset=%u flags=%lx\n",
             s->name, (unsigned long)s->size, s->size,
             oo_order(s->oo), s->offset, flags);
     return -EINVAL;
@@ -4514,7 +4518,7 @@ static ssize_t slabs_cpu_partial_show(struct
kmem_cache *s, char *buf)

 #ifdef CONFIG_SMP
     for_each_online_cpu(cpu) {
-        struct page *page = per_cpu_ptr(s->cpu_slab, cpu) ->partial;
+        struct page *page = per_cpu_ptr(s->cpu_slab, cpu)->partial;

         if (page && len < PAGE_SIZE - 20)
             len += sprintf(buf + len, " C%d=%d(%d)", cpu,
@@ -4810,7 +4814,7 @@ static void clear_stat(struct kmem_cache *s,
enum stat_item si)
         per_cpu_ptr(s->cpu_slab, cpu)->stat[si] = 0;
 }

-#define STAT_ATTR(si, text)                     \
+#define STAT_ATTR(si, text)                    \
 static ssize_t text##_show(struct kmem_cache *s, char *buf)    \
 {                                \
     return show_stat(s, buf, si);                \
@@ -4991,6 +4995,7 @@ static ssize_t slab_attr_store(struct kobject *kobj,
          */
         for_each_memcg_cache_index(i) {
             struct kmem_cache *c = cache_from_memcg_idx(s, i);
+
             if (c)
                 attribute->store(c, buf, len);
         }
-- 
1.7.10.4
